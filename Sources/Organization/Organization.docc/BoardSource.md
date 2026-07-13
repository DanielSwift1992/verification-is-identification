# How the board is written

> Note: Read back from the compiled type, the structure the build actually proved, not the file a human formatted. Comments and spacing live in the source file; the shape lives here, and the two cannot disagree.

```swift
BoardContent {
    BoardRow {
        SpanHosted {
            BoardColumn {
                ToDoDisplayName.self
                Layered {
                    SpanSoftShadowed {
                        TaskCardFacePlain.self
                    }
                    Layered {
                        SpanHosted {
                            CardTextRow {
                                TaskTitleSpan {
                                    OnboardNewHireDisplayName.self
                                }
                            }
                        }
                        Layered {
                            SpanHosted {
                                CardTextRow {
                                    TaskAssigneeSpan {
                                        Carol.self
                                    }
                                }
                            }
                            SpanHosted {
                                TaskChipRow {
                                    SpanLowered {
                                        ChipY.self
                                        Layered {
                                            StatusChipTrack {
                                                SurfaceTrack.self
                                            }
                                            SpanHosted {
                                                StatusChipInterior {
                                                    TextPrimary.self
                                                    ToDoDisplayName.self
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Layered {
                    SpanSoftShadowed {
                        TaskCardFacePlain.self
                    }
                    Layered {
                        SpanHosted {
                            CardTextRow {
                                TaskTitleSpan {
                                    ArchiveOldRepositoriesDisplayName.self
                                }
                            }
                        }
                        Layered {
                            SpanHosted {
                                CardTextRow {
                                    TaskAssigneeSpan {
                                        Dave.self
                                    }
                                }
                            }
                            SpanHosted {
                                TaskChipRow {
                                    SpanLowered {
                                        ChipY.self
                                        Layered {
                                            StatusChipTrack {
                                                SurfaceTrack.self
                                            }
                                            SpanHosted {
                                                StatusChipInterior {
                                                    TextPrimary.self
                                                    ToDoDisplayName.self
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                SpanNothing.self
                SpanNothing.self
            }
        }
        SpanHosted {
            BoardColumn {
                InProgressDisplayName.self
                Layered {
                    SpanSoftShadowed {
                        TaskCardFacePlain.self
                    }
                    Layered {
                        SpanHosted {
                            CardTextRow {
                                TaskTitleSpan {
                                    RotateVaultKeysDisplayName.self
                                }
                            }
                        }
                        Layered {
                            SpanHosted {
                                CardTextRow {
                                    TaskAssigneeSpan {
                                        Dave.self
                                    }
                                }
                            }
                            SpanHosted {
                                TaskChipRow {
                                    SpanLowered {
                                        ChipY.self
                                        Layered {
                                            StatusChipTrack {
                                                ActionRole.self
                                            }
                                            SpanHosted {
                                                StatusChipInterior {
                                                    OnActionRole.self
                                                    InProgressDisplayName.self
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Layered {
                    SpanSoftShadowed {
                        TaskCardFacePlain.self
                    }
                    Layered {
                        SpanHosted {
                            CardTextRow {
                                TaskTitleSpan {
                                    ReviewImprovementPlanPolicyDisplayName.self
                                }
                            }
                        }
                        Layered {
                            SpanHosted {
                                CardTextRow {
                                    TaskAssigneeSpan {
                                        Bob.self
                                    }
                                }
                            }
                            SpanHosted {
                                TaskChipRow {
                                    SpanLowered {
                                        ChipY.self
                                        Layered {
                                            StatusChipTrack {
                                                ActionRole.self
                                            }
                                            SpanHosted {
                                                StatusChipInterior {
                                                    OnActionRole.self
                                                    InProgressDisplayName.self
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Layered {
                    SpanSoftShadowed {
                        TaskCardFacePlain.self
                    }
                    Layered {
                        SpanHosted {
                            CardTextRow {
                                TaskTitleSpan {
                                    FinanceReconciliationDisplayName.self
                                }
                            }
                        }
                        Layered {
                            SpanHosted {
                                CardTextRow {
                                    TaskAssigneeSpan {
                                        Alice.self
                                    }
                                }
                            }
                            SpanHosted {
                                TaskChipRow {
                                    SpanLowered {
                                        ChipY.self
                                        Layered {
                                            StatusChipTrack {
                                                ActionRole.self
                                            }
                                            SpanHosted {
                                                StatusChipInterior {
                                                    OnActionRole.self
                                                    InProgressDisplayName.self
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                SpanNothing.self
            }
        }
        SpanHosted {
            BoardColumn {
                DoneDisplayName.self
                Layered {
                    SpanSoftShadowed {
                        TaskCardFacePlain.self
                    }
                    Layered {
                        SpanHosted {
                            CardTextRow {
                                TaskTitleSpan {
                                    Q3AccessAuditDisplayName.self
                                }
                            }
                        }
                        Layered {
                            SpanHosted {
                                CardTextRow {
                                    TaskAssigneeSpan {
                                        Alice.self
                                    }
                                }
                            }
                            SpanHosted {
                                TaskChipRow {
                                    SpanLowered {
                                        ChipY.self
                                        Layered {
                                            StatusChipTrack {
                                                AccentRole.self
                                            }
                                            SpanHosted {
                                                StatusChipInterior {
                                                    OnAccent.self
                                                    DoneDisplayName.self
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Layered {
                    SpanSoftShadowed {
                        TaskCardFacePlain.self
                    }
                    Layered {
                        SpanHosted {
                            CardTextRow {
                                TaskTitleSpan {
                                    UpdateOrganizationChartDisplayName.self
                                }
                            }
                        }
                        Layered {
                            SpanHosted {
                                CardTextRow {
                                    TaskAssigneeSpan {
                                        Carol.self
                                    }
                                }
                            }
                            SpanHosted {
                                TaskChipRow {
                                    SpanLowered {
                                        ChipY.self
                                        Layered {
                                            StatusChipTrack {
                                                AccentRole.self
                                            }
                                            SpanHosted {
                                                StatusChipInterior {
                                                    OnAccent.self
                                                    DoneDisplayName.self
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                SpanNothing.self
                SpanNothing.self
            }
        }
    }
    BoardReveals.self
}
```

[back to the board](doc:Board)
