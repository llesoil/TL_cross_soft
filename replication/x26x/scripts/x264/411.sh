#!/bin/sh

numb='412'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 4.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 40 --keyint 280 --lookahead-threads 2 --min-keyint 27 --qp 0 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset veryslow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.0,1.1,4.0,0.2,0.9,0.4,1,1,4,40,280,2,27,0,5,3,64,38,3,2000,1:1,dia,crop,veryslow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"