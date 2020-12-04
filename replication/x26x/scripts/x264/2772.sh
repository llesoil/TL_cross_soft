#!/bin/sh

numb='2773'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 3.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 45 --keyint 300 --lookahead-threads 4 --min-keyint 20 --qp 30 --qpstep 5 --qpmin 1 --qpmax 64 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset veryfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.0,1.2,1.4,3.6,0.2,0.7,0.6,2,2,2,45,300,4,20,30,5,1,64,28,5,1000,-2:-2,umh,show,veryfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"