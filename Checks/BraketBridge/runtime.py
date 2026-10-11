"""Oracle-free boundary for checked continuations and actual acquired bits."""
import json

def decode_runtime(execution, existing_record, raw_payload, contact_reply=None):
    """Only public records and measured SDK bits cross this working boundary.

    The contact reply, when present, is prepended to the existing record, as
    required by the checked export. No case name, fixture, or hidden valuation
    is accepted. The payload has already been measured and is not returned.
    """
    require(type(existing_record) is str and all(b in "01" for b in existing_record),
            "existing record must be a bit string")
    require(type(raw_payload) is int and raw_payload in (0, 1), "invalid SDK payload bit")
    require(contact_reply is None or type(contact_reply) is int and contact_reply in (0, 1),
            "invalid SDK contact bit")
    record = existing_record if contact_reply is None else str(contact_reply) + existing_record
    bound = bind_continuation(execution, record)
    require(bound["measure_payload"] and bound["gates"] == [],
            "terminal route does not support an unknown-quantum-state continuation")
    return raw_payload ^ bound["relabel"]


def public_terminal_shape(execution):
    """Check the exported terminal shape without any realized source value."""
    require(execution["measure_payload"] and execution["output"] == "one-classical-bit",
            "unknown quantum State is unsupported by this terminal route")
    shapes = []
    for key in execution["by_record"]:
        bound = bind_continuation(execution, key)
        require(bound["gates"] == [], "terminal acquisition cannot apply a late quantum correction")
        shapes.append(bound["analyzer"])
    require(shapes and all(shape == shapes[0] for shape in shapes),
            "this route requires a contact-independent payload analyzer")
    return shapes[0]

EXECUTION_FIELDS = {"schema", "payload", "input_records", "by_record", "analyzer",
                    "measure_payload", "output", "record_release", "reference"}

class CheckFailure(RuntimeError):
    pass


def require(condition, message):
    if not condition:
        raise CheckFailure(message)


def write_json(path, value):
    temporary = path.with_name(path.name + ".tmp")
    temporary.write_text(json.dumps(value, indent=2, allow_nan=False) + "\n", encoding="utf-8")
    temporary.replace(path)


def unique_object(pairs):
    output = {}
    for key, value in pairs:
        require(key not in output, "duplicate JSON key {!r}".format(key))
        output[key] = value
    return output


def load_json(path):
    def bad_constant(value):
        raise CheckFailure("non-finite JSON constant: " + value)
    return json.loads(path.read_text(encoding="utf-8"), object_pairs_hook=unique_object,
                      parse_constant=bad_constant)


def bind_continuation(execution, acquired_record):
    """The working binding boundary: no fixture/source/valuation argument.

    The only varying runtime input is the acquired record string. Surplus
    fields, latent-value dictionaries, extra bits and unknown keys are errors.
    """
    require(isinstance(execution, dict) and set(execution) == EXECUTION_FIELDS, "invalid executable continuation fields")
    require(execution["schema"] == "vi.braket.execution.v1" and type(execution["payload"]) is int
            and execution["payload"] == 0, "unsupported executable schema/payload address")
    records = execution["input_records"]
    require(isinstance(records, list) and records == ["r{}".format(i) for i in range(len(records))]
            and len(records) <= 4, "unsupported runtime record addresses")
    require(type(acquired_record) is str, "runtime input must be only the acquired record string")
    require(len(acquired_record) == len(records)
            and all(bit in "01" for bit in acquired_record), "extra or invalid runtime record bits")
    require(isinstance(execution["by_record"], dict) and acquired_record in execution["by_record"],
            "unavailable runtime record")
    branch = execution["by_record"][acquired_record]
    require(isinstance(branch, dict) and set(branch) == {"gates", "relabel"}, "unsupported executable branch fields")
    require(isinstance(branch["gates"], list) and all(gate in ("x", "y", "z") for gate in branch["gates"]),
            "unsupported executable correction gate")
    require(type(branch["relabel"]) is int and branch["relabel"] in (0, 1), "invalid executable outcome relabeling")
    require(isinstance(execution["analyzer"], list)
            and all(gate in ("h", "s") for gate in execution["analyzer"]), "unsupported executable analyzer")
    require(type(execution["measure_payload"]) is bool, "invalid executable output mode")
    if execution["measure_payload"]:
        require(execution["output"] == "one-classical-bit" and branch["gates"] == [],
                "this measurement interface admits relabeling, not additional payload correction")
    else:
        require(execution["output"] == "unknown-quantum-state" and execution["analyzer"] == []
                and branch["relabel"] == 0, "state output may not measure or relabel its payload")
    return {"gates": list(branch["gates"]), "relabel": branch["relabel"],
            "analyzer": list(execution["analyzer"]), "measure_payload": execution["measure_payload"]}


