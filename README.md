# lnxd/debian-base

This Docker image serves as a minimal Debian-based base for my other Docker containers. It contains a curated list of tools I utilse regularly when accessing containers with `docker exec -ti name zsh`. The purpose of this image is to provide a stable and consistent foundation for my containers.

The image is based on `debian:bullseye-slim` and includes a bare minimum of packages to ensure a small image size and fast build times. I've tried to only include packages that provide a balance of functionality and minimalism.

By using this image as a base, you can ensure that your containers have access to the tools you need, without including unnecessary packages. This can help to keep your containers small and efficient. Additionally, using a common base image can simplify maintenance and make it easier to switch between different containers.

This image is not intended to be a one-size-fits-all solution, and you may need to add additional packages to meet the specific needs of your containers. However, it provides a solid foundation for building your own containers and can save you time in the initial setup.

If you have any suggestions for improvements or additions to the included packages, feel free to create a pull request or open an issue on the GitHub repository.
