#!/bin/sh

numb='728'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 5.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 45 --keyint 210 --lookahead-threads 1 --min-keyint 24 --qp 0 --qpstep 4 --qpmin 4 --qpmax 61 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset slower --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.0,1.6,1.0,5.0,0.4,0.7,0.2,2,2,4,45,210,1,24,0,4,4,61,28,2,2000,1:1,umh,crop,slower,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"