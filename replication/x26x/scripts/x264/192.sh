#!/bin/sh

numb='193'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 3.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.6 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 45 --keyint 300 --lookahead-threads 3 --min-keyint 23 --qp 30 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset superfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.1,1.2,3.8,0.4,0.8,0.6,0,2,4,45,300,3,23,30,4,2,69,18,2,2000,-1:-1,umh,crop,superfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"