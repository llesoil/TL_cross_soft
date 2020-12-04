#!/bin/sh

numb='2459'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 4.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 14 --crf 35 --keyint 250 --lookahead-threads 1 --min-keyint 26 --qp 20 --qpstep 4 --qpmin 4 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset superfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.5,1.4,4.6,0.2,0.7,0.6,1,2,14,35,250,1,26,20,4,4,66,38,2,1000,1:1,umh,show,superfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"