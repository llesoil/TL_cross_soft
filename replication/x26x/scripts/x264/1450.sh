#!/bin/sh

numb='1451'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 3.2 --qblur 0.2 --qcomp 0.7 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 16 --crf 35 --keyint 200 --lookahead-threads 0 --min-keyint 21 --qp 50 --qpstep 4 --qpmin 2 --qpmax 66 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset slower --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.6,1.0,3.2,0.2,0.7,0.1,3,0,16,35,200,0,21,50,4,2,66,38,4,1000,1:1,dia,show,slower,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"