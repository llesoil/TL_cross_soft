#!/bin/sh

numb='922'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 2.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.5 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 10 --keyint 230 --lookahead-threads 4 --min-keyint 21 --qp 40 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.5,1.0,2.4,0.6,0.7,0.5,1,1,12,10,230,4,21,40,5,3,63,18,4,1000,1:1,umh,crop,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"