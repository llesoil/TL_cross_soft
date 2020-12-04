#!/bin/sh

numb='299'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 3.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 5 --keyint 240 --lookahead-threads 0 --min-keyint 29 --qp 40 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset veryslow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.0,1.2,3.4,0.4,0.8,0.7,0,0,10,5,240,0,29,40,4,3,63,48,5,2000,-2:-2,umh,crop,veryslow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"