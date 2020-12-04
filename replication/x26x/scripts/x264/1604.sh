#!/bin/sh

numb='1605'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 0.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.7 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 10 --keyint 270 --lookahead-threads 3 --min-keyint 30 --qp 0 --qpstep 5 --qpmin 2 --qpmax 62 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset ultrafast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.0,1.2,0.2,0.3,0.6,0.7,2,0,16,10,270,3,30,0,5,2,62,38,3,1000,1:1,hex,crop,ultrafast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"