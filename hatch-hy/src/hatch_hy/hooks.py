from hatchling.plugin import hookimpl


@hookimpl
def hatch_register_template():
    from hatch_hy.template import HyTemplate

    return HyTemplate
