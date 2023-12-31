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
#define PRINT_HEADER(cstring) printf("x\\\033[1m%s\033[0m\n", cstring)
#define PRINT_INFO(title, cstring) printf("\033[1m%s\033[0m %s\n", title, cstring)
#define PRINT_TIME(double) printf("\033[1;92m\u2713\033[0;92m %.3fs\033[0m\n", double)
#define PRINT_ERROR(cstring) printf("\033[1;91m\u2717\033[0;91m %s\033[0m\n", cstring)

#define TEMPLATE_JSON5 \
"_x: 0,\n" \
"project: '%@',\n" \
"require: [\n" \
"  'git',\n" \
"  'nano',\n" \
"  'xcodebuild'\n" \
"],\n" \
"scripts: {\n" \
"  install: {\n" \
"    info: 'install ...',\n" \
"    run: [\n" \
"      'echo download http://127.0.0.1/sdk',\n" \
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
