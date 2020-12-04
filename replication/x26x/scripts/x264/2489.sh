#!/bin/sh

numb='2490'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 2.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 6 --crf 30 --keyint 280 --lookahead-threads 0 --min-keyint 25 --qp 20 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset veryslow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,3.0,1.5,1.0,2.4,0.3,0.7,0.6,0,1,6,30,280,0,25,20,3,1,63,38,4,2000,1:1,hex,crop,veryslow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"