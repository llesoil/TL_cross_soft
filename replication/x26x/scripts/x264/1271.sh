#!/bin/sh

numb='1272'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 1.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 10 --keyint 280 --lookahead-threads 3 --min-keyint 20 --qp 30 --qpstep 4 --qpmin 4 --qpmax 69 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset ultrafast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,3.0,1.1,1.2,1.8,0.5,0.9,0.3,0,2,14,10,280,3,20,30,4,4,69,38,6,2000,-2:-2,dia,show,ultrafast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"