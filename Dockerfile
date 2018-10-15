FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 6731
EXPOSE 44370

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
#COPY ["StudentOS.csproj", "StudentOS/"]
COPY [".", "StudentOS/"]
RUN dotnet restore "StudentOS/StudentOS.csproj"

WORKDIR "/src/StudentOS"
RUN dotnet build "StudentOS.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "StudentOS.csproj" -c Release -o /app

RUN chmod +x ./entrypoint.sh
CMD /bin/bash ./entrypoint.sh

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "StudentOS.dll"]

