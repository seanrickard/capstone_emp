FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source
RUN curl -sL https://deb.nodesource.com/setup_10.x |  bash -
RUN apt-get install -y nodejs
COPY *.csproj .
RUN dotnet restore
COPY . .
RUN dotnet publish "./capstone.csproj" --output "./dist" --configuration Release --no-restore
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine AS base
WORKDIR /app
COPY --from=build /source/dist .
EXPOSE 80
ENTRYPOINT ["dotnet", "capstone.dll"]
