#!/bin/sh

numb='172'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 2.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 45 --keyint 220 --lookahead-threads 1 --min-keyint 27 --qp 20 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset faster --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.0,1.0,1.3,2.2,0.5,0.6,0.1,0,2,0,45,220,1,27,20,4,2,63,18,2,1000,-1:-1,umh,show,faster,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"