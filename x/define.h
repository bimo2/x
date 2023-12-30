//
//  define.h
//  x
//
//  Created by Bimal Bhagrath on 2023-12-24.
//

#ifndef DEFINE_H
#define DEFINE_H

#define VERSION "0.1"
#define BUILD "1A"
#define COMPILER 0

#ifndef BUILD_NUMBER
#define BUILD_NUMBER 0
#endif

#define X_JSON "x.json"
#define X_JSON5 "x.json5"

#define DOCS_URL "https://json5.dev"

#define PRINT(cstring) printf("%s\n", cstring)
#define PRINT_INFO(title, cstring) printf("\033[1m%s\033[0m %s\n", title, cstring);

#define PRINT_STATUS(status, cstring) if (status > 0) { \
    _PRINT_1(cstring) \
} else { \
    _PRINT_0(cstring) \
}

#define _PRINT_0(cstring) printf("\033[1;92m\u2713\033[0;92m %s\033[0m\n", cstring);
#define _PRINT_1(cstring) printf("\033[1;91m\u2717\033[0;91m %s\033[0m\n", cstring);

#define TEMPLATE_JSON5 \
"_x: 0,\n" \
"repo: '%@',\n" \
"dependencies: {\n" \
"  git: 'git',\n" \
"  xcode: [\n" \
"    'xcrun',\n" \
"    'xcodebuild'\n" \
"  ]\n" \
"},\n" \
"scripts: {\n" \
"  install: {\n" \
"    info: 'install ...',\n" \
"    run: [\n" \
"      'echo download #host -> 127.0.0.1#/sdk',\n" \
"      'echo install -a'\n" \
"    ]\n" \
"  },\n" \
"  start: {\n" \
"    info: 'start ...',\n" \
"    run: 'echo server -p #port -> 4000#'\n" \
"  },\n" \
"  build: {\n" \
"    info: 'build ...',\n" \
"    run: 'echo build -o #bin!#'\n" \
"  },\n" \
"  test: {\n" \
"    info: 'test ...',\n" \
"    run: 'echo test #suite#'\n" \
"  }\n" \
"}\n"

#endif // DEFINE_H
