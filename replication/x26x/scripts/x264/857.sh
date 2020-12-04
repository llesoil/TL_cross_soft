#!/bin/sh

numb='858'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 2.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 30 --keyint 250 --lookahead-threads 1 --min-keyint 22 --qp 40 --qpstep 3 --qpmin 2 --qpmax 69 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset medium --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.0,1.6,1.3,2.6,0.5,0.9,0.6,3,1,16,30,250,1,22,40,3,2,69,18,2,2000,-2:-2,dia,crop,medium,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"