// https://stackoverflow.com/a/5624139
const hexToRgb = (hex) => {
  const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result
    ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16),
      }
    : null;
};

const toFixed3 = (num) => num.toFixed(3);

const getGLSLColorFromHex = (color) => {
  const rgb = hexToRgb(color);
  return `vec3(${toFixed3(rgb.r / 255)},${toFixed3(rgb.g / 255)},${toFixed3(
    rgb.b / 255
  )})`;
};
