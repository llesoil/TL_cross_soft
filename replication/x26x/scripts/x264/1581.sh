#!/bin/sh

numb='1582'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 30 --keyint 250 --lookahead-threads 3 --min-keyint 22 --qp 40 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.3,1.0,4.0,0.3,0.9,0.1,0,2,16,30,250,3,22,40,4,2,62,18,6,2000,1:1,dia,show,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"