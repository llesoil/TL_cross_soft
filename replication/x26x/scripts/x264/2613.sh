#!/bin/sh

numb='2614'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 4.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 35 --keyint 200 --lookahead-threads 0 --min-keyint 30 --qp 0 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset slower --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.5,1.0,1.4,4.0,0.2,0.7,0.8,0,0,8,35,200,0,30,0,3,2,62,48,2,1000,1:1,umh,crop,slower,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"