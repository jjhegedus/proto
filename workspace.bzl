def _relocate_built_go_proto_library_for_publishing_impl(ctx):

  ctx.actions.run_shell(
    inputs = ctx.files.srcs,
    outputs = [ctx.outputs.executable],
    command = "\n".join(["echo origin_path=$(realpath \"%s\") \&\& proto_name=%s \&\& import_path=%s \&\& dest_filename=\"\$\"{proto_name}.pb.go \&\& src_path=\"\$\"{proto_name}_go_%s_/\"\$\"{import_path}/\"\$\"{dest_filename} \&\& cp \"\$\"{src_path} \"\$\"{origin_path} \&\& chmod 777 \"\$\"{origin_path}/\"\$\"{dest_filename} >> %s" % (f.path.split("/").pop().split(".").pop(0), f.path.split(".").pop(0).split("/").pop(0), ctx.attr.import_path, f.path.split(".").pop(),
              ctx.outputs.executable.path) for f in ctx.files.srcs]),
    execution_requirements = {
        "no-sandbox": "1",
        "no-cache": "1",
        "no-remote": "1",
        "local": "1",
    },
  )

relocate_go_proto_library = rule(
    implementation=_relocate_built_go_proto_library_for_publishing_impl,
    executable=True,
    attrs={
      "srcs": attr.label_list(allow_files=True),
      "import_path": attr.string(),
    }
)