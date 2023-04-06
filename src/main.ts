import { open } from 'node:fs/promises';
import { writeColor } from './color.js';
import { Ray } from './ray.js';
import { Vec3, Point3, Color } from './vec3.js';


function doesHitSphere(center: Point3, radius: number, r: Ray) {
	const oc = Vec3.sub(r.origin, center);
	const a = Vec3.dot(r.direction, r.direction);
	const b = 2 * Vec3.dot(oc, r.direction);
	const c = Vec3.dot(oc, oc) - (radius * radius);
	const discriminant = (b * b) - (4 * a * c);

	return (discriminant > 0);
}

function getRayColor(r: Ray) {
	if (doesHitSphere(new Point3(0, 0, -1), 0.5, r)) return new Color(1, 0, 0);

	const unitDirection = Vec3.unitVector(r.direction);
	const t = 0.5 * (unitDirection.y + 1);

	return Color.add(Color.scale(new Color(1, 1, 1), 1 - t), Color.scale(new Color(0.5, 0.7, 1), t));
}

async function main() {
	process.stdout.write(`\n\n-------------\n| RAYTRACER |\n-------------\n\n`)

	//
	// Image
	//

	const image = await open('./image.ppm', 'w');
	const aspectRatio = 16 / 9;
	const imageWidth = 400;
	const imageHeight = Math.trunc(imageWidth / aspectRatio);


	//
	// Camera
	//

	const viewportHeight = 2;
	const viewportWidth = aspectRatio * viewportHeight;
	const focalLength = 1;

	const origin = new Point3(0, 0, 0);
	const horizontal = new Vec3(viewportWidth, 0, 0);
	const vertical = new Vec3(0, viewportHeight, 0);
	const lowerLeftCorner = Vec3.sub(Vec3.sub(Vec3.sub(origin, Vec3.down(horizontal, 2)), Vec3.down(vertical, 2)), new Vec3(0, 0, focalLength));


	//
	// Render
	//

	await image.write(`P3\n${imageWidth} ${imageHeight}\n255\n`);

	for (let j = imageHeight - 1; j >= 0; j--) {
		process.stdout.write(`\rScanlines remaining: ${j}  `);

		for (let i = 0; i < imageWidth; i++) {
			const u = i / (imageWidth - 1);
			const v = j / (imageWidth - 1);
			const r = new Ray(origin, Vec3.sub(Vec3.add(Vec3.add(lowerLeftCorner, Vec3.scale(horizontal, u)), Vec3.scale(vertical, v)), origin));
			const pixelColor = getRayColor(r);

			await writeColor(image, pixelColor);
		}
	}

	await image.close();
	process.stdout.write('\nDone. \n\n');
}

await main();
