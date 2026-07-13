# How the dashboard is written

> Note: Read back from the compiled type, the structure the build actually proved, not the file a human formatted. Comments and spacing live in the source file; the shape lives here, and the two cannot disagree.

```swift
PulseDashboard {
    Air {
        16
    }
    Fixed {
        120
        SpanHosted {
            PulseKpiRow.self
        }
    }
    Air {
        24
    }
    Fixed {
        176
        SpanHosted {
            PulseBarsRow.self
        }
    }
    Fixed {
        Swift.Never.self
        SpanHosted {
            SelfShowingBadgeRow {
                SitePath {
                    PulseSource.self
                }
            }
        }
    }
    Air {
        24
    }
}
```

[back to the dashboard](doc:CompanyDashboard)
