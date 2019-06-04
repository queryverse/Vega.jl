module.exports = function(data, options) {
  return typeof data === "string"
      ? Buffer.from(data, typeof options === "string" ? options
          : options && options.encoding !== null ? options.encoding
          : "utf8")
      : data;
};
