import std.stdio;
import std.process;
import std.array; //to use str.split("\n");
import std.path; //2023-11-05 19:48:44 - baseName() extension()
import std.file;
import std.string;

const APP_NAME = "Find2Links";

int[string] OCCURRENCES; //Memory

int tryCreateLink(string filename,string destfilename)
{
    if( std.file.exists(destfilename) )
    {
        writeln("File '"~destfilename~"' already exists.");
        return -1;
    }else
    {
        //Can Create
        std.file.symlink(filename , destfilename);
        if(std.file.exists(destfilename) )
        {
            //try check if they are the same :                  
            if(std.file.getSize(filename) != std.file.getSize(destfilename) )
            {
                writeln("'"~ destfilename ~ "' created OK.");  
                return 0;
            }else
            {
                //Try another name
                //Compose a new name
                string ext = std.path.extension(destfilename);
                string nameNoExt = std.path.stripExtension(destfilename);
                //build OCCURRENCES table :
                if( destfilename ! in OCCURRENCES)
                {
                    OCCURRENCES[destfilename ] = 1; //First occurrence
                }else
                {
                    OCCURRENCES[destfilename] ++; // Let's increment..
                }
                import std.conv;                
                destfilename =  nameNoExt~"_"~to!string(OCCURRENCES[destfilename]) ~ ext;
                writeln("New name = ", destfilename );
                halt;
                //tryCreateLink(filename, destfilename);
                return 3;
            }
        }
    }
    return 5;
}//tryCreateLink



void main(string [] args)
{

    writeln(APP_NAME);

    string destination = "./dest";

    string command = "find /usr/share/hydrogen -iname \"*kick*\" ";
    writeln("command is = ",command);
    auto ls = executeShell(command);
    if (ls.status != 0) 
    {
        writeln("Failed to retrieve file listing");    
    }
    else
    {
        string [] lines = ls.output.split("\n");
        foreach( line ; lines )
        {
            //writeln("line=",std.string.strip(line));
            string trimmed = std.string.strip(line);
            if( trimmed.length  )
            {                
                string filename = line;
                string basename = baseName(line);
                string destfilename =  destination~"/"~basename;
                writeln("symlink("~filename~","~destfilename~"); ");
                //writeln("File Size: ", std.file.getSize(filename)  );
                int res = tryCreateLink(filename, destfilename);                
                writeln("TryCreateLink = ", res);
            }//trimmed line exists
        }
    }    
}//main
