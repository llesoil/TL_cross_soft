#!/bin/sh

numb='309'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 4.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 0 --keyint 210 --lookahead-threads 3 --min-keyint 26 --qp 10 --qpstep 4 --qpmin 1 --qpmax 61 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset veryslow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,3.0,1.2,1.0,4.2,0.4,0.7,0.5,2,0,2,0,210,3,26,10,4,1,61,18,6,2000,-1:-1,hex,crop,veryslow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"