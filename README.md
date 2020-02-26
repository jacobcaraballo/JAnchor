###### Jacob Caraballo
# JAnchor

JAnchor simplifies the usage of NSLayoutConstraints. It handles most simple constraints.

---

### Without JAnchor:

```swift
NSLayoutConstraint.activate([
	view.widthAnchor.constraint(equalTo: superview.widthAnchor),
	view.heightAnchor.constraint(equalTo: superview.heightAnchor),
	view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
	view.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
])
```

### **With JAnchor**:

```swift
view.anchor(to: superview)
	.width()
	.height()
	.centerX()
	.centerY()
```


The following code samples do the same thing as the above code:

```swift
view.anchor(to: superview)
	.size()
	.center()
```
```swift
view.anchor(to: superview)
	.frame()
```
---

### Other Examples

Anchor `view` to the *safeAreaLayoutGuide* of `superview`:

```swift
view.anchor(to: superview, usesSafeArea: true)
	.frame()
```

Anchor the *topAnchor* of `button1` to the *bottomAnchor* of `button2`

```swift
button1.anchor(to: button2)
	.topToBottom()
```

Anchor to *bottomAnchor* and *rightAnchor* of `view1` to those of `view2`:

```swift
view1.anchor(to: view2)
	.bottomRight()
```

Anchor the *widthAnchor* of `view1` to half of the widthAnchor of `view2`:

```swift
view1.anchor(to: view2)
	.width(multiplier: 0.5)
```
---

### Multiple Anchors

#### You can anchor multiple views at once, when they follow the same constraints.

Let's say you have this situation:

```swift
NSLayoutConstraint.activate([
	view1.widthAnchor.constraint(equalTo: superview1.widthAnchor),
	view1.heightAnchor.constraint(equalTo: superview1.heightAnchor),
	view1.centerXAnchor.constraint(equalTo: superview1.centerXAnchor),
	view1.centerYAnchor.constraint(equalTo: superview1.centerYAnchor),

	view2.widthAnchor.constraint(equalTo: superview2.widthAnchor),
	view2.heightAnchor.constraint(equalTo: superview2.heightAnchor),
	view2.centerXAnchor.constraint(equalTo: superview2.centerXAnchor),
	view2.centerYAnchor.constraint(equalTo: superview2.centerYAnchor)

	view3.widthAnchor.constraint(equalTo: superview3.widthAnchor),
	view3.heightAnchor.constraint(equalTo: superview3.heightAnchor),
	view3.centerXAnchor.constraint(equalTo: superview3.centerXAnchor),
	view3.centerYAnchor.constraint(equalTo: superview3.centerYAnchor)
])
```
With **JAnchor**, all you have to do is this:

```swift
[view1, view2, view3].anchor(to: [superview1, superview2, superview3])
	.frame()
```
---

### JAnchor Objects
Anchors return a **JAnchor** object which contains all activated `NSLayoutConstraints`. So that you can update them later if needed.

For Example:

```swift
let anchor = view.anchor(to: superview)
	.width(constant: 50)
	.height()
	.center()
```
Now, we can change the width by getting the width constraint and changing its constant value:

```swift
anchor.get(for: .width).constant = 100
```
