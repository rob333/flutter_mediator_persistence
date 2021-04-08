Initialize registration:

```mermaid
stateDiagram-v2
    WatchedVariable --> Host : belong to
    Subscriber --> Host : register aspects
    note left of Subscriber
    A Widget, to be rebuilt
    when watched variables updates.
    end note
    note right of Host
    The InheritedModel, to rebuild
    descendant widgets with aspects.
    end note
```

When updating:

```mermaid
stateDiagram-v2
    WatchedVariable --> Host : notify through Pub
    Host --> Subscriber : rebuild
    Controller --> WatchedVariable : updates
```

Initialize registration:

```mermaid
graph LR
    W(WatchedVariable) -- belong to --> H((Host:InheritedModel))
    S(Subscriber Widget) -- register aspects --> H
```

When updating:

```mermaid
graph LR
    W(WatchedVariable) --notify aspects --> H
    H((Host)) -- rebuild with aspects--> S(Subscriber)
    C(Controller) -- update --> W
```
