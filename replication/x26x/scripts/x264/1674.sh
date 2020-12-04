#!/bin/sh

numb='1675'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 3.8 --qblur 0.5 --qcomp 0.7 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 0 --crf 10 --keyint 260 --lookahead-threads 3 --min-keyint 22 --qp 20 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset ultrafast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,3.0,1.2,1.1,3.8,0.5,0.7,0.1,2,1,0,10,260,3,22,20,4,0,65,28,3,1000,-2:-2,umh,crop,ultrafast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"