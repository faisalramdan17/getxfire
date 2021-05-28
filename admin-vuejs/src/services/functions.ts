/**
 * Returns an object from proxy data.
 * @param proxyObject - Proxy object
 * @param append - To add extra data to return value.
 */

export function proxy(proxyObject: any, append = {}) {
  return Object.assign(JSON.parse(JSON.stringify(proxyObject)), append);
}
