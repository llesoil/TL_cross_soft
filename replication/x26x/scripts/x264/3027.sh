#!/bin/sh

numb='3028'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 1.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.0 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 30 --keyint 210 --lookahead-threads 2 --min-keyint 30 --qp 30 --qpstep 4 --qpmin 1 --qpmax 69 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset medium --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.5,1.5,1.4,1.6,0.6,0.8,0.0,2,0,2,30,210,2,30,30,4,1,69,38,2,2000,-2:-2,umh,show,medium,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"