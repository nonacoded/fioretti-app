# API documentation

# GET `/api/events`
`Input:` nothing

`Output:`
```dart
[
    {
        _id: ObjectID, // event ID
        title: String, // event title
        description: String, // event description
        date: Date, // event date
        location: String, // event location
        price: Int // event price in cents
    },
    // ect...
]
```


# POST `/api/events`
`Input:`

```dart
{
	event: 
    {
        title: String, // event title
        description: String, // event descr
        date: Int, // event date in seconds since epoch
        location: String, // event location
        price: Int // event price in eurocents
    }
}
```