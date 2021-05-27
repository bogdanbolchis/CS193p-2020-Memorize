# SwiftUI

## Lecture 2

### MVVM

#### Model
- UI Independent
- Data + Logic
- "The Truth"

#### View
- Reflects the Model
- Stateless
- Declared
- Reactive
- automatically observes publications, pulls data and redraws
- talks to the ViewModel by calling VM's "Intent" functions

#### ViewModel
- binds View to Model
- interpreter of the model for the view (e.g. convert data types)
- notices changes in the Model
- publishes "something changed" (doesn't talk to the model automatically)
- Processes User "Intent" (e.g. choosing an item) and modifies the Model
- always a class (not a struct)

#### `struct` and `class`
- value type | reference type (stored on the heap)
- copied when passed or assigned | passed around via _pointers_
- copy on write (lazy copying, when structs get changed) | automatically reference counted
- functional programming | object-oriented programming
- no inheritance | inheritance
- "free" member-wise init for all vars | init for no vars
- explicitly stated mutability | always mutable

#### Vocabulary
- "in the interest of time, I will cover..."
- "function arguments"
- "underbar" = _
- <, > = "angle brackets"

## Lecture 3

### Combine

@Published - the view model publishes its model
@ObservedObject - the view observes the view model

### Protocols

Protocol extensions and default implementations in them are the heart of swift functional programming.

#### SwiftUI layout
- container views (HStack, VStack, ZStack) offer space to the views inside them
- views then choose what size they want to be, depending on what they are offered
- container views then position the views inside of them

#### Container Views
- stacks divide up the space offered to them amongst their subviews
- ForEach defers to its container to lay out the Views inside of it
- Modifiers (e.g. `.padding()`) essentially contain the View they modify. Some do layout.

#### HStack and VStack
- offer space to its least flexible (with respect to sizing) subviews first.
- inflexible views: 
	- Image (it wants to be a fixed size)
	- Text (always wants to size to fit its text)
- flexible view: Rounded Rectangle (always uses the space offered)
- after an offered view takes what it wants, its size is removed from the space available
- then the stack moves on to the next "least flexible" views.
- rinse and repeat
- after the views inside the stack choose their own size, the stack sizes itself to fit them
- stack's choice of who to offer space to can be overridden with `.layoutPriority(Double)`

#### Spacer(minLength: CGFloat)
- always takes all the space offered to it
- draws nothing

#### Divider
- dividing line cross-wise to the way the stack is laying out
- takes the minimum space needed to fit the line in the direction the stack is going

#### ViewModifiers
- some involved in the layout process: .padding(), .aspectRatio()

#### GeometryReader
- used to read the size given to a body by the layout system

#### Vocabulary
- "as a little aside"

## Lecture 4

### enum 
- value type
- CaseIterable --> gives you static .allCases

### Optional
- ?? -- does Optional defaulting/nil coalescing operator

### Group
- can be used for returning some View when optionals are involved
- or just when making a group of views have the same opacity

## Lecture 5

### Access control
- private(set) - *readonly*: setting is private, reading not
### @ViewBuilder
- convenient syntax for returning lists of Views
- can use @ViewBuilder to *mark a parameter that returns a View*
- TupleView - two to ten Views
- ZStack, HStack, VStack, ForEach, Group are ViewBuilder
### Shape
- protocol, inherits from View
- ShapeStyle - protocol adopted by Color, ImagePaint, AngularGradient, LinearGradient
- required method: `path(in rect: CGRect) -> Path`
- `Angle`: takes degrees or radians (0->2*PI)
### ViewModifier
- .padding(), .aspectRatio()
- used for animation

		protocol ViewModifier {
			associatedType Content
			
			func body(content: Content) -> some View {
				return ... // some View that represents a modification of Content
			}
		}


## Lecture 6

### Property Observers
- watch a `var` and execute code when it changes
### @State
- your view is read only. it's useless to have a `var`
- only `let`s or computed `var`s make sense
- views are supposed to be stateless, reflecting the model, except... when views need State:
	- always temporary: editing mode
	- you want to kick off an *animation*
	- you show a view temporarily to notify the user
- any `var` used for temporary state should be marked with @State
- will cause a redraw, like @ObservedObject
- use them sparingly
### Animation
- the point: make UX less abrupt, draw attention
- what can be animated?
	- appearance/disappearance of views already on screen
	- changes to arguments to Animatable view modifiers
	- changes to arguments to the creation of Shapes
- two ways to kick off an animation:
	- implicitly, using .animation(Animation)\. On containers, it doesn't work as expected, but it propagates the animation to all views.
	- explicitly, by wrapping code making changes with `withAnimation(Animation) { (...) }`
	- explicit animations don't override implicit animations
### Transitions
- a pair of ViewModifiers
- one of the modifiers is the *before* modification of the view that's on the move
- the other is the *after* modification
- only work with explicit animations
### Type erasure
- the actual type of the transitions use generics
- AnyTransition is a struct with an init that takes a generic
### .onAppear/.onDisappear
- can be used on containers, in conjunction with .withAnimation()
### Animatable
- to adopt, implement `var animatableData: Type`
- `Type` has to implement `VectorArithmetic`
#### Vocab
- @ = at sign
- kick off an animation

## Lecture 7

### Color vs UIColor
- Color: specifier, ShapeStyle, View
- UIColor: system class for colors
- Color(uiColor:)
### Image vs UIImage
- Image: View
- Image(_ name: String) -- to load assets
- Image(systemName:) to load system images (available in SF Symbols)
- UIImage -- comes from UIKit
- Image(uiImage:)
### DispatchQueue.main, DispatchQueue.global(qos:)
- queue.async {}, queue.sync {}

#### Vocab

- "time permitting"

## Lecture 8

### UserDefaults
- the `Any` type exists in swift for example for backwards compatibility with things like `UserDefaults`
### Gestures
- `myView.onTapGesture {...}` - discrete gestures
- non-discrete: `DragGesture`, `MagnificationGesture`, `RotationGesture`
- `myView.gesture(aGesture)` // aGesture must implement the `Gesture` protocol, for example TapGesture(count: 2)
- gesture handlers look like `.onEnded`, or `.onChanged`
- `@GestureState` helps to track the state of the gesture. A declared var is needed, and it's used by the following view modifier...
- `.updating($myGestureState) { value, myGestureState, transaction in {...}` 

#### Vocab
- "there's quite a bit involved there"
- json = jay-sawn
- "we're pressed for time right now"
- "I'm not going to go through all the detail of the code"

## Lecture 9
### Property Wrappers
- @State, @Published, @ObservedObject
- syntactic sugar for a struct:

		@Published
		var emojiArt: EmojiArt
		
		// is equivalent to:

		struct Published {
			var wrappedValue: EmojiArt
			var projectedValue: Publisher<EmojiArt, Never> // this type depends on wrapper
		}
		
		var _emojiArt: Published = Published(wrappedValue: EmojiArt())
		
		var emojiArt: EmojiArt {
			get { _emojiArt.wrappedValue // + other operations }
			set { _emojiArt.wrappedValue = newValue // + other ops}
		}
		 
- @State
	- wrappedValue is anything
	- what it does: stores the wrappedValue in the heap
	- $projectedValue is a Binding (to that value in the heap)
- @ObservedObject
	- wrappedValue: anything that implements the ObservableObject
	- what it does: invalidates the View when wrappedValue does objectWillChange.send()
	- $projectedValue: a Binding to the vars of the wrappedValue (a ViewModel)
- @Binding
	- wrappedValue: a value that is bound to something else
	- what it does
		- gets/sets the value of the wrappedValue from some other source
		- when the bound value changes, invalidates the view
	- projected value: self
- @Binding - about a single source of truth. A cooler delegate.
- @EnvironmentObject
	- similar to @ObservedObject, but:
	- visible to all Views in one body (except modally presented ones)
	- useful when a number of Views are sharing the same ViewModel
	- wrappedValue is ObservableObject, obtained via .environmentObject()
	- what it does: invalidates the View when wrappedValue does objectWillChange.send()
	- $projectedValue: a Binding to the vars of the wrappedValue
- @Environment
	- _unrelated_ to @EnvironmentObject
	- wrappedValue: some var in EnvironmentValues
	- what it does: gets/sets a value of some var in EnvironmentValues
	- $projectedValue: none

## Publisher<Output, Failure>
- Output is the type of the thing being published
- Failure is the type of the thing it communicates if it fails while trying to publish
- Failure must implement the Error protocol
- if the Publisher doesn't deal with errors, the Failure can be Never
- useful for 
	- listening(subscribing) to its values 
	- transform its values on the fly
	- move its values to somewhere else

			onReceive(publisher) { thingThePublisherPublishes in 
					// do something with thingThePublisherPublishes
			} 
			
		
#### Vocab
- "we're not going to talk in detail about..."

## Lecture 10

#### Vocab 
- "before we get any farther here"

## Lecture 11

- Picker, List
- the picker's selected item should have the `.tag(object)` applied, where the type of the object is the same as the picker's `selection` object type
- `Form`s inside a `NavigationView` can help with laying out the Picker

## Lecture 12 - Core Data
## Lecture 13 - Persistence
- CloudKit
	- Record Type - like a class/struct
	- Field - like a var in a class/struct
	- Record - an "instance" of Record Type
	- Reference - a "pointer" to another Record
	- Database - a place where Records are stored
	- Zone - a sub-area of a Database
	- Container - a collection of Databases
	- Query - a Database search
	- Subscription - a "standing Query" which sends push notifications when changes occur
