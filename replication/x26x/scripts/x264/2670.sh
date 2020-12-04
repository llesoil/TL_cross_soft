#!/bin/sh

numb='2671'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 4.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 5 --keyint 260 --lookahead-threads 0 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 4 --qpmax 66 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryslow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.0,1.5,1.1,4.8,0.3,0.9,0.0,2,2,0,5,260,0,30,30,5,4,66,48,2,1000,-1:-1,umh,show,veryslow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"