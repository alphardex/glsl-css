import { readdir, writeFile } from "fs/promises";

import { dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));

const BASEPATH = __dirname;

const IGNOREPATH = ["node_modules", "vendors", "preview", ".git", "bonus"];

// https://stackoverflow.com/a/24594123
const getDirectories = async (source) =>
  (await readdir(source, { withFileTypes: true }))
    .filter((dirent) => dirent.isDirectory())
    .map((dirent) => dirent.name);

const folders = (await getDirectories(BASEPATH)).filter(
  (item) => !IGNOREPATH.includes(item)
);

let result = [];

for (const folder of folders) {
  const files = await readdir(folder);
  const list = files.map((file) => {
    const [order, _] = file.split("-");
    return {
      file,
      order,
    };
  });
  list.sort((a, b) => Number(a.order) - Number(b.order));
  result.push({
    folder,
    list,
  });
}

result = result.flat();

const data = {
  entries: result,
};

const dataStr = JSON.stringify(data);

await writeFile(`${BASEPATH}/files.json`, dataStr);
