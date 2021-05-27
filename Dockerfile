FROM mcr.microsoft.com/dotnet/sdk:5.0 as build_stage
RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
COPY . ./app
WORKDIR /app
RUN dotnet build
WORKDIR /app/DotnetTemplate.Web
RUN npm install
RUN npm run build
RUN dotnet publish -c Release -o out
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build_stage /app/DotnetTemplate.Web/out .
EXPOSE 5000
ENTRYPOINT [ "dotnet" ,"DotnetTemplate.Web.dll" ]