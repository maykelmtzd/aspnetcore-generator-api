# Build Stage
FROM microsoft/aspnetcore-build:2 AS build-env
WORKDIR /generator

#restore
COPY /api/api.csproj ./api/
RUN dotnet restore ./api/api.csproj
COPY /tests/tests.csproj ./tests/
RUN dotnet restore ./tests/tests.csproj

#copy source
COPY . .

#tests
RUN dotnet test tests/tests.csproj

#publish
RUN dotnet publish ./api/api.csproj -o /publish

#runtime stage
FROM microsoft/aspnetcore:2
WORKDIR /publish
COPY --from=build-env /publish .
ENTRYPOINT ["dotnet", "api.dll"]
