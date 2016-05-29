## Chapter 1 - Introducing Phoenix

### Scaling by Forgetting
* Solve scalability problem by treating each tiny piece of a user interaction as an identical request
    * Application doesn't save the state, simply looks up the user and the context of the conversation of user session
    * Cost: Developer must keep track of the state of each request

### Processes and Channels
* Elixir uses *lightweight* processes; not operating system process
    * Can create hundreds of thousands of processes without breaking a sweat
    * Lightweight means connections can be conversations
      * aka *channels*

#### Channels
* Different frameworks are beginnign to support channels
* But only Elixir gurantees isolation and concurrency
    * *Isolation* guarantees that if a bug affects one channel, all other channels continue running
    * *Concurrency* means one channel can never block another one
    * This key advantage means that the UI never becomes unresponsive because the user started a heavy action
