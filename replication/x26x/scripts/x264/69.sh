#!/bin/sh

numb='70'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 2.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.7 --aq-mode 1 --b-adapt 1 --bframes 2 --crf 20 --keyint 210 --lookahead-threads 3 --min-keyint 20 --qp 20 --qpstep 4 --qpmin 0 --qpmax 66 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset superfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.4,1.0,2.6,0.4,0.8,0.7,1,1,2,20,210,3,20,20,4,0,66,18,6,2000,-2:-2,dia,show,superfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"