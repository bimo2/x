//
//  XSDefine.h
//  x
//
//  Created by Bimal Bhagrath on 2023-12-24.
//

#ifndef XSDEFINE_H
#define XSDEFINE_H

#define X_JSON "x.json"
#define X_JSON5 "x.json5"

#define VERSION "0.1"
#define BUILD_VERSION "1A"

#ifndef BUILD_NUMBER
#define BUILD_NUMBER 1
#endif

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

#endif /* XSDEFINE_H */
