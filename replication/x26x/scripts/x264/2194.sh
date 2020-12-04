#!/bin/sh

numb='2195'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 4.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 50 --keyint 220 --lookahead-threads 4 --min-keyint 20 --qp 0 --qpstep 3 --qpmin 4 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset superfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.3,1.4,4.4,0.4,0.8,0.5,0,1,14,50,220,4,20,0,3,4,63,48,3,1000,-1:-1,dia,show,superfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"