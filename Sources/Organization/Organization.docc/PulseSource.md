# How the dashboard is written

> Note: Read back from the compiled type: the structure the build proved, with every magnitude folded to the count the source names through the dictionary. Comments and spacing live in the source file. The shape lives here, and the two cannot disagree.

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
        Never.self
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
