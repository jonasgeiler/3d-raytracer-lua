import type { FileHandle } from 'node:fs/promises';
import type { Color } from './vec3.js'

export async function writeColor(fh: FileHandle, pixelColor: Color) {
	await fh.write(`${Math.trunc(255.999 * pixelColor.x)} ${Math.trunc(255.999 * pixelColor.y)} ${Math.trunc(255.999 * pixelColor.z)}\n`);
}
