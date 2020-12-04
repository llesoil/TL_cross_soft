#!/bin/sh

numb='2892'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 2 --bframes 8 --crf 35 --keyint 240 --lookahead-threads 3 --min-keyint 20 --qp 40 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset veryslow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.0,1.4,1.2,1.0,0.6,0.9,0.7,0,2,8,35,240,3,20,40,4,2,69,38,6,1000,1:1,umh,crop,veryslow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"