#!/bin/sh

numb='910'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 0.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 45 --keyint 210 --lookahead-threads 4 --min-keyint 25 --qp 0 --qpstep 3 --qpmin 0 --qpmax 68 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryslow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,2.5,1.1,1.2,0.2,0.2,0.8,0.0,3,1,14,45,210,4,25,0,3,0,68,18,6,2000,-1:-1,dia,crop,veryslow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"