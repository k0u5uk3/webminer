// This file is generated by mruby-cli. Do not touch.
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <signal.h>

/* Include the mruby header */
#include <mruby.h>
#include <mruby/array.h>

mrb_value mrb_alarm(mrb_state *mrb, mrb_value self)
{
   mrb_int time;
   mrb_get_args(mrb, "i", &time);
   alarm(time);
   return mrb_nil_value();
}

int main(int argc, char *argv[])
{
  mrb_state *mrb = mrb_open();
  mrb_value ARGV = mrb_ary_new_capa(mrb, argc);
  int i;
  int return_value;

  struct RClass *c = mrb_define_class(mrb, "Timeout", mrb->object_class);
  mrb_define_method(mrb, c, "alarm", mrb_alarm, MRB_ARGS_REQ(1));

  for (i = 0; i < argc; i++) {
    mrb_ary_push(mrb, ARGV, mrb_str_new_cstr(mrb, argv[i]));
  }
  mrb_define_global_const(mrb, "ARGV", ARGV);

  // call __main__(ARGV)
  mrb_funcall(mrb, mrb_top_self(mrb), "__main__", 1, ARGV);

  return_value = EXIT_SUCCESS;

  if (mrb->exc) {
    mrb_print_error(mrb);
    return_value = EXIT_FAILURE;
  }
  mrb_close(mrb);

  return return_value;
}
