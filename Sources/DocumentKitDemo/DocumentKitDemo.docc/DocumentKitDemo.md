# ``DocumentKitDemo``

Reads this owner's declared layout compositions with its supplied binding.

## Documentation and demo pages

The SDK relations are documented at [DocumentKit](https://danielswift1992.github.io/verification-is-identification/documentation/documentkit/).

- [Source of the declared canvas](https://danielswift1992.github.io/verification-is-identification/documentation/documentkitdemo/self-showing-example-source)
- [Station A](https://danielswift1992.github.io/verification-is-identification/documentation/documentkitdemo/vector-tour-station-a)
- [Station B](https://danielswift1992.github.io/verification-is-identification/documentation/documentkitdemo/vector-tour-station-b)
- [Covered visible claim](https://danielswift1992.github.io/verification-is-identification/documentation/documentkitdemo/coveredvisibleclaim)


## Declared layout compositions

![Canvas](vector-canvas-example)

![Hover pair](vector-hover-example)

![Canvas with its source link](vector-selfshowing-example)

![Station A](vector-tour-station-a)

![Station B](vector-tour-station-b)

![Owner roles](roles-plate)


## Markup declarations and readings

### Symbol

Declaration

```swift
Symbol { DemoModuleTitle.self }
```


Compiled markup

```
``DocumentKitDemo``
```


``DocumentKitDemo``

### Page

Declaration

```swift
Page { DemoModuleTitle.self }
```


Compiled markup

```
<doc:DemoModuleTitle>
```


<doc:DemoModuleTitle>

### Link

Declaration

```swift
Link { SampleLabel.self; DemoModuleTitle.self }
```


Compiled markup

```
[demo module](doc:DemoModuleTitle)
```


[demo module](doc:DemoModuleTitle)

### Picture

Declaration

```swift
Picture { SampleLabel.self; SampleAsset.self }
```


Compiled markup

```
![demo module](example)
```


![demo module](example)

### Framed

Declaration

```swift
Framed { SampleText.self }
```


Compiled markup

```
| supplied content | 
| --- | 


```


| supplied content | 
| --- | 



### Spacer

Declaration

```swift
SideBySide { Spacer<WeightOf<U1>>.self; PanelOf { SampleText.self }; Spacer<WeightOf<U1>>.self }
```


Compiled markup

```
@Row {
@Column(size: 1) {

}
@Column {
supplied content
}
@Column(size: 1) {

}
}

```


@Row {
@Column(size: 1) {

}
@Column {
supplied content
}
@Column(size: 1) {

}
}


### Gap

Declaration

```swift
SpaceBetween<SampleLeft, SampleRight>.self
```


Compiled markup

```

```




### Table

Declaration

```swift
Table {
    TableRow { TableCell { SampleLeft.self }; TableCell { SampleRight.self } }
    TableRow { TableCell { RuleMark.self }; TableCell { RuleMark.self } }
    TableRow { TableCell { SampleText.self }; TableCell { SampleText.self } }
}
```


Compiled markup

```
| left place | right place | 
| --- | --- | 
| supplied content | supplied content | 


```


| left place | right place | 
| --- | --- | 
| supplied content | supplied content | 



### List

Declaration

```swift
ListItem { SampleLeft.self }
ListItem { SampleRight.self }
```


Compiled markup

```
- left place
- right place

```


- left place
- right place


### Callouts

Declaration

```swift
Noted { SampleText.self }
Flagged { SampleText.self }
Warned { SampleText.self }
Tipped { SampleText.self }
```


Compiled markup

```
> Note: supplied content

> Important: supplied content

> Warning: supplied content

> Tip: supplied content


```


> Note: supplied content

> Important: supplied content

> Warning: supplied content

> Tip: supplied content



### Tabs

Declaration

```swift
TabGroup {
    At.self; TabLabel.self; ParenOpen.self; Quote.self; SampleFirstTab.self; Quote.self; ParenClose.self; OpenBrace.self
    SampleLeft.self; Newline.self; CloseBrace.self
    At.self; TabLabel.self; ParenOpen.self; Quote.self; SampleSecondTab.self; Quote.self; ParenClose.self; OpenBrace.self
    SampleRight.self; Newline.self; CloseBrace.self
}
```


Compiled markup

```
@TabNavigator {
@Tab("First") {
left place
}
@Tab("Second") {
right place
}
}

```


@TabNavigator {
@Tab("First") {
left place
}
@Tab("Second") {
right place
}
}


### Columns

Declaration

```swift
SideBySide { PanelOf { SampleLeft.self }; PanelOf { SampleRight.self } }
```


Compiled markup

```
@Row {
@Column {
left place
}
@Column {
right place
}
}

```


@Row {
@Column {
left place
}
@Column {
right place
}
}


### WeightedColumns

Declaration

```swift
SideBySide {
    SizedPanel { SampleLeft.self; WeightOf<U1>.self }
    SizedPanel { SampleRight.self; WeightOf<U2>.self }
}
```


Compiled markup

```
@Row {
@Column(size: 1) {
left place
}
@Column(size: 2) {
right place
}
}

```


@Row {
@Column(size: 1) {
left place
}
@Column(size: 2) {
right place
}
}


### Tally

Declaration

```swift
DocumentKit.Tally { U2.self }
```


Compiled markup

```
2
```


2

