#!/bin/sh

numb='485'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 4.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 2 --b-adapt 1 --bframes 0 --crf 35 --keyint 200 --lookahead-threads 1 --min-keyint 22 --qp 20 --qpstep 4 --qpmin 3 --qpmax 61 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset veryslow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.6,1.1,4.4,0.2,0.9,0.3,2,1,0,35,200,1,22,20,4,3,61,18,3,1000,1:1,hex,crop,veryslow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"