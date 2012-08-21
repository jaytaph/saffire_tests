#include <histedit.h>
#include <stdio.h>

char cur_prompt[40];
static int count = 0;

char *prompt(EditLine *el) {
    sprintf(cur_prompt, "#%d> ", count++);
    return cur_prompt;
}




int main(int argc, char *argv) {
    EditLine *el;
    History *hist;
    HistEvent ev;
    const char *line;
    int count;

    el = el_init(&argv[0], stdin, stdout, stderr);
    el_set(el, EL_PROMPT, &prompt);

    hist = history_init();
    if (! hist) {
        fprintf(stderr, "cannot initialize history\n");
    }
    history(hist, &ev, H_SETSIZE, 800);
    el_set(el, EL_HIST, history, hist);
    el_set(el, EL_EDITOR, "emacs");

    history(hist, &ev, H_LOAD, ".history");

    while (1) {
        const char *line = el_gets(el, &count);
        if (count > 0) {
            history(hist, &ev, H_ENTER, line);
            history(hist, &ev, H_SAVE, ".history");
            printf("LINE: %s", line);
        }
    }


    history_end(hist);
    el_end(el);

    return 0;
}

int tab_completion(int cnt, int key) {

}
