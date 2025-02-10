---
title: "Pushing the boundaries of Streamlit"
class: prose
description: "How I learned to stop worrying and love Streamlit's execution model"
quote: "I recently had the pleasure of using Streamlit for the first time"
retweet: "https://x.com/twitchard/status/1861834040229470691"
---
I recently had the pleasure of using [Streamlit](https://streamlit.io/) for the first time (for [this demo](https://x.com/hume_ai), [code here](https://github.com/jerhadf/voice-computer-use)). Streamlit is a Python library for making Web UIs. I really like it! 

I also had some challenges trying to make some inherently “event-driven” UI play nicely with Streamlit’s unique execution model.

The goals of this post:

- Increase your interest in trying Streamlit if you never used it.
- Show you some things that might be difficult in Streamlit, so that you can steer clear of trying it in cases when it’s not the right tool.
- Give you some tips if you happen to find yourself trying to do the same sort of tricky things I needed to.
- In the course of things, I also discuss voice AI and Anthropic’s new Computer Use API.

## Eww... frontend in Python?

My first reaction to "Python library for frontend" was "eww, why would you ever do this, just write Javascript" but I got over this pretty quickly. Streamlit is high-level and opinionated enough so that -- while the Python <> Javascript bridge definitely adds a little complexity -- it's not really that troublesome. If you need low-level control over the details of your app's appearance and behavior and access to web primitives -- you shouldn't be using Streamlit. You should use Streamlit if you have some interesting code in Python, and want it to have a functional, interactive web UI that looks decent and standard, but you don't care too much about the details.

## Streamlit's control flow

In Streamlit, defining a Web UI looks a lot like defining a script than runs from top to bottom. For example

```python
import streamlit as st

name = st.text_input("What is your name?")
height_in_inches = st.number_input("Enter your height (in inches)", min_value=2 * 12, step=1, max_value=9*12)
is_taller_than_taylor_swift = height_in_inches > 5 * 12 + 11

if st.button("Greet me"):
  st.text(f"Hello, {name}, you are {'taller' if is_taller_than_taylor_swift else 'not taller'} than Taylor Swift!")

```

The cute/clever thing about this is that the "results" of widgets like text inputs or buttons are mapped immediately to variables. You don't have to explicitly hook up event handlers as you would in e.g. React.

```jsx
const [name, setName] = useState("")
return <div>
  ...
  <input value={name} onChange={(e) => setName(e.target.value)}/>
  ...
</div>

```

How do things update? Every time something changes, the **entire Streamlit script runs again from top to bottom**, and the return value of a widget will be equal to the updated value.

If a button is clicked it only “stays clicked” for the very next run. If you want something (like the effects of a button click) to persist past that, you have to explicitly store it in `session_state`. For the above example:

```diff
  if st.button("Greet me"):
-   st.text(f"Hello, {name}, you are {'taller' if is_taller_than_taylor_swift else 'not taller'} than Taylor Swift!")
+   st.session_state.greeting = f"Hello, {name}, you are {'taller' if is_taller_than_taylor_swift else 'not taller'} than Taylor Swift!"

+ greeting = st.session_state.get('greeting', None)
+ if greeting:
+   st.text(greeting)
```

this will prevent the greeting from disappearing when you change the height after having clicked the button.

I like this a lot. You can very directly express the data flow of your UI. It’s not too hard to reason about control flow, at least in the happy path.

If performance starts to become a problem, there are callbacks and features like ["fragments"](https://docs.streamlit.io/develop/api-reference/execution-flow/st.fragment) that you can introduce that will complicate the execution flow a little more but let you optimize a little bit.

Unfortunately, once you start to stray from the happy path, things get ugly.

## Adventures in computer use

The reason I was exploring Streamlit in the first place was that Anthropic -- the AI company behind Claude -- recently released a [demo app](https://github.com/anthropics/anthropic-quickstarts/tree/main/computer-use-demo) for their [computer use API](https://docs.anthropic.com/en/docs/build-with-claude/computer-use) that used Streamlit. My goal was to adapt their demo so that -- instead of *typing* input into it, you could *speak* to [Hume](https://hume.ai/)'s [Empathic Voice Interface](https://dev.hume.ai/docs/empathic-voice-interface-evi/overview) in order to trigger the computer use.

Adding voice to a computer-using agent is, in my biased opinion, a huge and very obvious improvement. The problem with writing a text prompt is that it requires a bunch of emotional *activation energy.* You have to do much of your thinking all up front and compose it a prompt in one go. Whereas if you just start clicking around doing the task yourself you only have to do your thinking one step at a time, and it's a lot easier emotionally to get the momentum going. 

Voice — particularly interruptible, conversational voice interfaces like EVI — can remove some of the “writer’s block” awkwardness of the text interface. for some people at least, it takes less activation energy to click a button and start talking then it does to draft a prompt and click submit.

Anyway, that's the motivation. Here's how Anthropic's computer use demo works, before any attempts to add voice:

1. A Python process runs on a Linux machine, and serves a Streamlit app.
2. The user of the demo types some instructions.
3. Those instructions go to the Anthropic API, which returns a response and a series of "tool use instructions", e.g. "move the mouse cursor to <coordinates>" or "enter keystrokes <text>" or "take a screenshot" or "run a shell command <bash>".
4. The python process (the same one that serves the streamlit app) is capable of shelling out and executing those instructions on the Linux machine it runs on. The results are collected and sent back to the Anthropic API, which iterates and responds with a message and more instructions to execute. This process (”the agentic sampling loop") repeats until the task is done or needs more user input.
5. Messages from the Anthropic API and descriptions of the ongoing tool use are displayed to the user by Streamlit as they happen.

My goal seemed simple.

1. Accept voice input from the user.
2. Narrate the messages coming back to the user from the Anthropic API.
3. Ideally, take advantage of EVI's interruptibility, so that the interaction can feel like a natural conversation and not just like using a voice command line.

This turned out **not** to be easy to do with Streamlit.

## Accessing audio input and output

The first obstacle is: Streamlit runs in a Python process on a server somewhere. That server, in general, is *not* the user’s personal machine, and so cannot directly access the user’s microphone and speaker. Those are only available through the browser. This means that the assumptions of [Hume’s guide to using EVI in Python](https://dev.hume.ai/docs/empathic-voice-interface-evi/quickstart/python#handling-audio) or anything you would find if you Googled “how to access the microphone in Python” are going to be broken.

If you web search “Streamlit microphone” you will find some community-built components for getting audio from the user’s microphone through the browser. The problem is: none of these seem to handle *streaming, real-time* audio. The way they work is, the user hits record, they user speaks, the user hits stop record, and then all the audio is transmitted at once over to the Python side for processing. That’s not how EVI works. EVI wants a constant stream of audio chunks that are 10ms long.

No fear: I quickly concluded I would need to make a [Streamlit custom component](https://docs.streamlit.io/develop/concepts/custom-components/create) and do most of the EVI stuff completely on the browser side. The idea was, the user would talk to EVI entirely in the browser, and then when EVI needed to trigger the computer use API would just send a message back to the Python side. Easy peasy, right?

## Long-running tasks

Things seemed to be all right for awhile. I was thinking about it a little wrong, Streamlit custom components don’t exactly “send messages” back to the Python side — this isn’t Javascript, where event emitters are a way of life. In Streamlit, you communicate with the Python side by “setting the component value”. When you set your component value, the entire Streamlit script will rerun.

This seemed to make sense. I had something like

```python
latest_message_from_evi = evi_chat(hume_api_key="nice try")
if latest_message_from_evi['type'] == 'user_input':
	computer_use_instructions = latest_message_from_evi['content']

# Now plug `computer_use_instructions` into the same place where the prompt
# from the text box used to go to trigger the Anthropic computer use
do_computer_use_stuff(computer_use_instructions)
```

The trouble was this: what if a new message came in from `evi_chat` while `do_computer_use_stuff` was running? Then the Streamlit script would immediately terminate so it could rerun. This was a huge problem, because `do_computer_use_stuff` very strongly assumed that it would never be interrupted. The people who wrote the Anthropic computer use demo kind of cheated. They disabled the entire UI while the computer use was happening, so you couldn’t interact with anything that would trigger a rerun. This was reasonable for them: the point of their demo was “look! isn’t this cool? the computer can do things by itself”. The point of my fork of their demo, on the other hand, was “look! isn’t this even cooler if you can converse with the AI that is using the computer and like, interrupt it and stuff?” so disabling interaction while computer use was happening would have defeated the purpose.

So, the way forward was for me to change `do_computer_use_stuff` so that it wouldn’t break if Streamlit had to re-run while it was in progress.

## Making things uninterruptable

What I ended up having to do was reimplement the computer use stuff so that

- It executed in a separate thread that wouldn’t be terminated when the script restarts.
- It could communicate the results of its progress back to the main Streamlit script (so, e.g. EVI could narrate to the user what was happening).

I also ended up rewriting the computer use code as a state machine that advanced with discrete state transitions. I think this made the control flow easier for me to reason about but in retrospect might not have been strictly necessary.

In any case, I’ll show you one way to do the “execute in a separate thread that won’t be terminated when the script restarts” bit:

```python
# This is boilerplate that you write when you want a background thread
# where you can use `asyncio` to schedule tasks on it.
class AsyncioThread(threading.Thread):
    def __init__(self):
        super().__init__(daemon=True)
        self.loop = asyncio.new_event_loop()

    def run(self):
        asyncio.set_event_loop(self.loop)
        self.loop.run_forever()
        
# st.cache_resource means that calling `worker_thread` will return a singleton
# instance of a thread that is *global* across all users and sessions.
@st.cache_resource()
def worker_thread():
    thread = AsyncioThread()
    thread.start()
    return thread

# However, each *session* has its own Queue where tasks that it schedules
# will write their results. This is *session-scoped*, so not global.
if 'worker_queue' not in st.session_state:
    st.session_state.worker_queue = Queue()
    
# Here's an example task that takes some time to finish executing
async def long_running_task(begin_time, queue):
    begin_task = time.time() - begin_time
    await asyncio.sleep(5)
    end_task = time.time() - begin_time
    # Put the result into the queue
    queue.put((begin_task, end_task))

# This reads results from the queue and adds them into `session_state`.
def update_finished_tasks():
    while not st.session_state.task_results_queue.empty():
        result = st.session_state.task_results_queue.get()
        st.session_state.finished.append(result)

def main():
		st.button("Click this button to trigger a rerun")
    if st.button("Start Long-Running Task"):
        asyncio.run_coroutine_threadsafe(
            long_running_task(st.session_state.begin, st.session_state.task_results_queue),
            st.session_state.asyncio_thread.loop
        )
        st.write("Task started...")

    # Update finished tasks from the queue
    update_finished_tasks()
	 
	  # Display completed tasks
    for idx, (begin_task, end_task) in enumerate(st.session_state.finished, 1):
        st.markdown(f"**Task {idx}** - Begun at: {begin_task:.2f}s, Ended at: {end_task:.2f}s")
```

Really, I think the code snippet mostly speaks for itself. “Here’s how you make a thread that doesn’t die, and here’s how you schedule tasks on it and get those results”.

What I don’t show is — what happens if, when one of those tasks finishes, you need to display its result right away, rather than waiting for an interaction to happen before it gets reflected in the ui? What you can do in that case is just block in a `while True` at the end of `main`, poll for a message to get added to the queue, and `st.rerun()` if something else in the Streamlit UI will want to reflect the result of the new message.

And that’s it basically! It’s doesn’t look too bad in the context of this very simplified code example. The challenge for me was figuring out how to take this stream of events I was receiving from my voice chat component, plus the stream of events that I was now getting from the computer use loop, and producing an appropriate action in every case. But that is just the fundamental challenge of asynchronous programming, there’s nothing unique to Streamlit about that.

## Hindsight

There’s a [community component]( https://github.com/whitphx/streamlit-webrtc) that [appears to be](https://towardsdatascience.com/developing-web-based-real-time-video-audio-processing-apps-quickly-with-streamlit-7c7bcd0bc5a8) a Streamlit custom component that accepts callbacks to give a more natural interface for working with realtime video/audio. Callbacks are not officially supported by the Streamlit custom component API, so I assume that this component is reaching into some sort of internals behind the scenes to make that happen.

This being my first time using Streamlit, I shied away from reaching into internals and tried to stick to the blessed path. In retrospect, though, it might have been easier to try and figure this out.

## Aside: recovering type-safety

I really like types. Types help me clarify my thinking, and they also help me put safeguards in place to prevent me from making stupid mistakes like typos.

Unfortunately, Streamlit’s `st.session_state` doesn’t have a very useful type (it’s basically `MutableMapping[str | int, Any]`). With this type, you can put anything in and get anything out. If you’re making a highly stateful Streamlit app with concurrency, this can get you into trouble.

What I ended up doing was setting a rule for myself: *never* access `st.session_state` directly and always go through a wrapper class `class State` with a more specific type. It looked basically like

```python
class State:
    _session_state: SessionStateProxy

    def __init__(self, session_state: SessionStateProxy):
        self._session_state = session_state
        State.setup_state(session_state)

    @staticmethod
    def setup_state(session_state: SessionStateProxy):
				...
				if 'worker_running' not in session_state:
            session_state.worker_running = False
        if 'debug' not in session_state:
            session_state.debug = False

		...
    @property
    def worker_running(self) -> bool:
        return self._session_state.worker_running

    @worker_running.setter
    def worker_running(self, value: bool):
        self._session_state.worker_running = value
    
    @property
    def debug(self) -> bool:
        return self._session_state.debug

    @debug.setter
    def debug(self, value: bool):
        self._session_state.debug = value

    # Many more properties
    ...
```

And then in my main function, I did

```python
state = State(st.session_state)
```

On a similar note, Python’s `Queue` class isn’t very typesafe either. (It would be nice if it took a generic parameter.) But you can wrap `Queue` in a similar way.

```python
class WorkerEventSuccess(TypedDict):
	type: Literal["success"]
	result: str
	
class WorkerEventFailure(TypedDict):
  type: Literal["failure"]
  error: str
 
WorkerEvent = WorkerEventSuccess | WorkerEventFailure
  
class WorkerQueue():
    _queue: Queue

    def __init__(self, queue):
        self._queue = queue

    def put(self, event: WorkerEvent):
        self._queue.put(event)

    def empty(self) -> bool:
        return self._queue.empty()

    def get(self) -> WorkerEvent:
        return self._queue.get()
```

## Last Words

Overall, I had a blast getting to know Streamlit. I think the “let’s try and make (re-)rendering a UI like (re-)running a Jupyter notebook” is just a really compelling idea. So, if you've been writing any Python, you should give Streamlit a try!
