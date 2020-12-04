#!/bin/sh

numb='2234'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 0.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 50 --keyint 300 --lookahead-threads 4 --min-keyint 29 --qp 30 --qpstep 4 --qpmin 1 --qpmax 69 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset slow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.5,1.4,0.8,0.6,0.6,0.2,0,0,10,50,300,4,29,30,4,1,69,38,4,2000,-2:-2,hex,show,slow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"